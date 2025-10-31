// ==UserScript==
// @name         QB Clickpad
// @description  在页面右下角放一块不可见、可点击的区域；点击它或用快捷键触发同一动作
// @match        *://*/*
// @run-at       document-end
// ==/UserScript==

(function () {
  // 1) 可改成你想要的区域位置/大小
  const PAD_STYLE = {
    position: 'fixed',
    right: '0',            // 贴右下角
    bottom: '0',
    width: '28vw',         // 宽度（可改：如 '300px' 或 '20vw'）
    height: '40vh',        // 高度
    zIndex: '2147483647',
    background: 'rgba(0,0,0,.05)', // 不可见
    // 想调试时可临时改成 'rgba(0,0,0,.05)'
  };

  // 2) 触发动作（你要“点击空白处”做的事都写这里）
  function onActivate(source = 'unknown') {
    // 示例：优先后退；不行就滚到页首
    if (history.length > 1) {
      history.back();
    } else {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }

  // 创建 clickpad
  const pad = document.createElement('div');
  pad.id = 'qb-clickpad';
  Object.assign(pad.style, PAD_STYLE);

  // 点击这块区域 → 触发动作
  pad.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    onActivate('clickpad');
  }, true);

  // 也支持“全局事件”触发（给快捷键用）
  window.addEventListener('qb-clickpad-activate', () => onActivate('event'));

  // 挂到文档上
  (document.body || document.documentElement).appendChild(pad);
})();
