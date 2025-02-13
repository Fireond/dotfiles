import vapoursynth as vs
from vapoursynth import core

clip = video_in
fps = container_fps or 23.976
freq = display_fps or 59.970
w, h = video_in_dw, video_in_dh

if (freq - fps < 2):
    raise Exception("Interpolation is not necessary.")

target_fps = 60

vw, vh = 2560, 1440

sp, ap, fp = """{
        gpu: 1
    }""", """{
        block: { w: 32, h: 16, overlap: 2 },
        main: {
            levels: 5,
            search: {
                type: 4, distance: -12, stad: false,
                coarse: { type: 4, distance: -2, trymany: true, bad: { range: 0 } }
            },
            penalty: { lambda: 5, plevel: 1.33, lsad: 3300, pzero: 110, pnbour: 50 }
        },
        refine: [{ thsad: 200 }, { thsad: 200, search: { type: 4, distance: -4 } }]
    }""", """{
        gpuid: 0,
        algo: 23, cubic: 1, rate: { num: %d, den: %d, abs: true },
        mask: { cover: 80, area: 30, area_sharp: 0.75 },
        scene: { mode: 1.5, limits: { scene: 6000, zero: 100, blocks: 40 } }
    }""" % (round(target_fps) * 1000, 1001)


def fit(clip, w, h, vw, vh):
    r = max(w/vw, h/vh)
    if r > 1:
        def f(x, s=4): return round(x/r/s)*s
        clip = clip.resize.Spline36(width=f(w), height=f(h))
    return clip


def toYUV420(clip):
    if clip.format.id == vs.YUV420P8:
        clip8 = clip
    elif clip.format.id == vs.YUV420P10:
        clip8 = clip.resize.Bilinear(format=vs.YUV420P8)
    else:
        clip = clip.resize.Bilinear(format=vs.YUV420P10)
        clip8 = clip.resize.Bilinear(format=vs.YUV420P8)
    return clip, clip8


def svpflow(clip, fps, sp, ap, fp):
    clip, clip8 = toYUV420(clip)
    s = core.svp1.Super(clip8, sp)
    r = s["clip"], s["data"]
    v = core.svp1.Analyse(*r, clip, ap)
    r = *r, v["clip"], v["data"]
    clip = core.svp2.SmoothFps(clip, *r, fp, src=clip, fps=fps)
    return clip


clip = fit(clip, w, h, vw, vh)
clip = svpflow(clip, fps, sp, ap, fp)
clip.set_output()
