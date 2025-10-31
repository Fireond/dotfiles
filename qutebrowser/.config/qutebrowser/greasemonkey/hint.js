(function () {
    'use strict';

    const host = window.location.host;
    const class_name = 'qutebrowser-custom-hint';

    window.addEventListener('load', function () {
        if (host === 'chat.deepseek.com') {
            let target_text = '开启新对话';
            let walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, null);

            let node;
            while ((node = walker.nextNode())) {
                if (node.nodeType === Node.TEXT_NODE && node.nodeValue === target_text) {
                    node.parentNode.classList.add(class_name);
                    break;
                }
            }
        }
    });

    const old_add_event_listener = Element.prototype.addEventListener;
    Element.prototype.addEventListener = function () {
        if (arguments[0] === 'click') {
            this.classList.add(class_name);
        }

        return old_add_event_listener.apply(this, arguments);
    };
})();
