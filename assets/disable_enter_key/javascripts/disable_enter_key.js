(function () {
  'use strict';

  const issueSubjectField = document.getElementById('issue_subject');
  if (issueSubjectField) {
    document.addEventListener('keydown', function (e) {
      if (e.target.id === 'issue_subject' && ((e.code && e.code === 'Enter') || (e.which && e.which === 13) || (e.keyCode && e.keyCode === 13))){
        if ((e.ctrlKey && !e.metaKey) || (!e.ctrlKey && e.metaKey)) {
          $(e.target).closest('form').submit();
        } else {
          e.preventDefault();
        }
      }
    });
  }
})();