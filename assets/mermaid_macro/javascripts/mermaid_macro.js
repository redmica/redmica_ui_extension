// The conversion process when drawing the page is performed by initAllMermaidMacro().
// After that, initMermaidMacro() is executed separately to support mermaid macro added by ajax, etc.

$(function() {
  initAllMermaidMacro();
});

function initAllMermaidMacro() {
  if (ShowErrorMessageIfIE()) { return false; }

  // Hide the target before the change by before-init-mermaid class until mermaid.initialize() or mermaid.init() is executed.
  // After executing mermaid.initialize() or mermaid.init(), remove the before-init-mermaid class to show it.
  mermaid.initialize({
    startOnLoad: true,
    mermaid: {
      callback:function() {
        $('.mermaid').removeClass('before-init-mermaid');
      }
    }
  });
  $('.mermaid').removeClass('before-init-mermaid');
}

function initMermaidMacro(id) {
  if (ShowErrorMessageIfIE()) { return false; }

  mermaid.init(undefined, '#' + id);
}

// Mermaidjs does not support IE. When IE users view the mermaid macro, they will see .mermaid-error.
function ShowErrorMessageIfIE() {
  var userAgent = window.navigator.userAgent.toLowerCase();
  if(userAgent.indexOf('msie') != -1 || userAgent.indexOf('trident') != -1) {
    $('.mermaid').hide();
    $('.mermaid-error').show();
    return true
  }
}