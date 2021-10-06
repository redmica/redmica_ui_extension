// The conversion process when drawing the page is performed by initAllMermaidMacro().
// After that, initMermaidMacro() is executed separately to support mermaid macro added by ajax, etc.

$(function() {
  initAllMermaidMacro();
});

function initAllMermaidMacro() {
  if (isMermaidjsIsAvailable() === false) { return false; }

  // Hide the target before the change by before-init-mermaid class until mermaid.initialize() or mermaid.init() is executed.
  // After executing mermaid.initialize() or mermaid.init(), remove the before-init-mermaid class to show it (ViewMermaidMacroContent).
  mermaid.initialize({
    startOnLoad: true,
    mermaid: { callback:function() { ViewMermaidMacroContent(); } }
  });
  ViewMermaidMacroContent();
}

function initMermaidMacro(id) {
  if (isMermaidjsIsAvailable() === false) { return false; }

  mermaid.init(undefined, '#' + id);
}

function isMermaidjsIsAvailable() {
  if (typeof mermaid === 'undefined') {
    ViewMermaidMacroContent();
    return false;
  }
  return true;
}

function ViewMermaidMacroContent() {
  $('.mermaid').removeClass('before-init-mermaid');
}
