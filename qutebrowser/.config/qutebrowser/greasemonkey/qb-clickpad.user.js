// ==UserScript==
// @name         qb-ghost-clicker
// @namespace    qb
// @version      1.0.0
// @description  在每个页面创建一个不可见但可点击、随页面浮动的元素
// @match        *://*/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function () {
  // 确保只创建一次
  if (window.__qbGhostInstalled) return;
  window.__qbGhostInstalled = true;

  // DOM 就绪后插入（document-start 下有些页面此时还没可插入的 body）
  const ready = fn => {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', fn, { once: true });
    } else {
      fn();
    }
  };

  ready(() => {
    // 已存在就别重复
    if (document.getElementById('qb-ghost')) return;

    const ghost = document.createElement('button');
    ghost.id = 'qb-ghost';
    ghost.type = 'button';
    ghost.textContent = '';                // 不显示文字
    ghost.title = 'qb-ghost';              // 便于调试
    Object.assign(ghost.style, {
      position: 'fixed',
      top: '0',
      left: '0',
      width: '1px',
      height: '1px',
      opacity: '0',                        // 完全不可见
      pointerEvents: 'auto',               // 仍可点击
      zIndex: '2147483647',                // 最高层
      border: '0',
      padding: '0',
      margin: '0',
      background: 'transparent',
    });

    // 你可以在这里挂任何需要的点击逻辑
    // 例如：ghost.addEventListener('click', () => console.log('ghost clicked'));

    document.documentElement.appendChild(ghost);
  });
})();
