#!/opt/homebrew/bin/python3
"""Inspect/restore macOS display origins; never change resolution or disable a screen."""
import argparse
import ctypes as C
import json
from pathlib import Path

class Point(C.Structure):
    _fields_ = [('x', C.c_double), ('y', C.c_double)]

class Size(C.Structure):
    _fields_ = [('width', C.c_double), ('height', C.c_double)]

class Rect(C.Structure):
    _fields_ = [('origin', Point), ('size', Size)]

cg = C.CDLL('/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics')
cf = C.CDLL('/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation')
sky = C.CDLL('/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight')

def declare(lib, name, result, *arguments):
    fn = getattr(lib, name)
    fn.restype, fn.argtypes = result, list(arguments)
    return fn

active = declare(cg, 'CGGetActiveDisplayList', C.c_int, C.c_uint32, C.POINTER(C.c_uint32), C.POINTER(C.c_uint32))
bounds = declare(cg, 'CGDisplayBounds', Rect, C.c_uint32)
builtin = declare(cg, 'CGDisplayIsBuiltin', C.c_uint32, C.c_uint32)
main_display = declare(cg, 'CGDisplayIsMain', C.c_uint32, C.c_uint32)
mirrored = declare(cg, 'CGDisplayIsInMirrorSet', C.c_uint32, C.c_uint32)
# Resolve UUID exactly as the installed OmniWM 0.6.10 does (read-only).
display_uuid = declare(sky, 'CGDisplayCreateUUIDFromDisplayID', C.c_void_p, C.c_uint32)
uuid_string = declare(cf, 'CFUUIDCreateString', C.c_void_p, C.c_void_p, C.c_void_p)
get_string = declare(cf, 'CFStringGetCString', C.c_bool, C.c_void_p, C.c_char_p, C.c_long, C.c_uint32)
release = declare(cf, 'CFRelease', None, C.c_void_p)
begin = declare(cg, 'CGBeginDisplayConfiguration', C.c_int, C.POINTER(C.c_void_p))
configure = declare(cg, 'CGConfigureDisplayOrigin', C.c_int, C.c_void_p, C.c_uint32, C.c_int32, C.c_int32)
complete = declare(cg, 'CGCompleteDisplayConfiguration', C.c_int, C.c_void_p, C.c_uint32)
cancel = declare(cg, 'CGCancelDisplayConfiguration', C.c_int, C.c_void_p)

def check(result, operation):
    if result != 0:
        raise RuntimeError(f'{operation} failed: CGError {result}')

def snapshot():
    identifiers = (C.c_uint32 * 32)()
    count = C.c_uint32()
    check(active(32, identifiers, C.byref(count)), 'CGGetActiveDisplayList')
    result = []
    for identifier in identifiers[:count.value]:
        value = display_uuid(identifier)
        if not value:
            raise RuntimeError('Display UUID unavailable')
        string = uuid_string(None, value)
        try:
            buffer = C.create_string_buffer(128)
            if not get_string(string, buffer, len(buffer), 0x08000100):
                raise RuntimeError('Display UUID cannot be decoded')
            uuid = buffer.value.decode()
        finally:
            release(string)
            release(value)
        frame = bounds(identifier)
        result.append({'id': identifier, 'uuid': uuid, 'builtin': bool(builtin(identifier)),
            'main': bool(main_display(identifier)), 'x': int(frame.origin.x), 'y': int(frame.origin.y),
            'width': int(frame.size.width), 'height': int(frame.size.height)})
    return result

def apply(requested, permanent):
    current = snapshot()
    by_uuid = {row['uuid']: row for row in current}
    if len(requested) != len(current) or {row['uuid'] for row in requested} != set(by_uuid):
        raise RuntimeError('Connected displays changed; refusing to guess')
    if sum(row['x'] == row['y'] == 0 for row in requested) != 1:
        raise RuntimeError('Exactly one display must keep the main origin')
    for row in requested:
        connected = by_uuid[row['uuid']]
        if (row['width'], row['height']) != (connected['width'], connected['height']) or mirrored(connected['id']):
            raise RuntimeError('Resolution or mirroring changed; refusing to guess')
    config = C.c_void_p()
    check(begin(C.byref(config)), 'CGBeginDisplayConfiguration')
    try:
        for row in requested:
            check(configure(config, by_uuid[row['uuid']]['id'], row['x'], row['y']), 'CGConfigureDisplayOrigin')
    except BaseException:
        cancel(config)
        raise
    check(complete(config, 2 if permanent else 1), 'CGCompleteDisplayConfiguration')

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    sub.add_parser('list')
    setter = sub.add_parser('apply')
    setter.add_argument('snapshot', type=Path)
    setter.add_argument('--permanent', action='store_true')
    args = parser.parse_args()
    if args.action == 'apply':
        apply(json.loads(args.snapshot.read_text()), args.permanent)
    print(json.dumps(snapshot(), ensure_ascii=False, indent=2))

if __name__ == '__main__':
    main()
