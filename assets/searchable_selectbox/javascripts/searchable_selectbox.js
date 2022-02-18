// Replace with select2 when the HTTP status of ajax request is a success.
// (by pure jquery)
$(document).ajaxSuccess(function() {
  replaceSelect2();
  initAssignToMeLink();
});

// Replace with select2 when the HTTP status of data-remote request is a success.
// (by rails-ujs)
$(document).on('ajax:success', function() {
  replaceSelect2();
  initAssignToMeLink();
});

// Override addEventListener to get that there is a native event.
EventTarget.prototype._addEventListener = EventTarget.prototype.addEventListener;
EventTarget.prototype.addEventListener = function(type, listener, options) {
   this._addEventListener(type, listener, options);
   // !String(listener).includes('triggered!'): Exclude events triggered by jQuery's trigger function
   if (type=='change' && this.tagName == 'SELECT' && !String(listener).includes('triggered!')) {
     $(this).attr('data-use-add-change-event-listener', true)
   }
};

$(function() {
  // Replace with select2 when loading page.
  replaceSelect2();

  initAssignToMeLink();

  // Fix Select2 search broken inside jQuery UI modal Dialog( https://github.com/select2/select2/issues/1246 )
  if ($.ui && $.ui.dialog && $.ui.dialog.prototype._allowInteraction) {
    var ui_dialog_interaction = $.ui.dialog.prototype._allowInteraction;
    $.ui.dialog.prototype._allowInteraction = function(e) {
      if ($(e.target).closest('.select2-dropdown').length) { return true; }
      return ui_dialog_interaction.apply(this, arguments);
    };
  };

  // Supports change of select box by filter function
  if ($('#query_form_with_buttons').length || $('form#query-form').length || $('form#query_form').length) {
    var oldAddFilter = window.addFilter;
    window.addFilter = function(field, operator, values){
      oldAddFilter(field, operator, values);
      $('#filters-table select:not([multiple]):not([data-remote]):not(.select2-hidden-accessible)').select2();
      $('#select2-add_filter_select-container.select2-selection__rendered').text('');
    }

    var oldToggleMultiSelect = window.toggleMultiSelect;
    window.toggleMultiSelect = function(el){
      oldToggleMultiSelect(el);
      if (el.attr('multiple')) {
        el.select2('destroy');
      } else {
        el.select2();
      }
    }
  }
});

function replaceSelect2() {
  // TODO: Need to support replace of select according to the click event.
  // Do not replace it with select2 until it corresponds.
  if ($('body').hasClass('controller-workflows')) {
    return;
  } else {
    var selectInTabular = $('.tabular .splitcontent select:not([multiple]):not([data-remote]):not(.select2-hidden-accessible)');
    if (selectInTabular.length) {
      selectInTabular.select2({
        width: 'style'
      }).on('select2:select', function() {
        retriggerChangeIfNativeEventExists($(this));
      });
    }

    var other = $('select:not([multiple]):not([data-remote]):not(.select2-hidden-accessible)');
    if (other.length) {
      other.select2().on('select2:select', function() {
        retriggerChangeIfNativeEventExists($(this));
      });
    }

    var excludedSelect = $('table.list td>select');
    if (excludedSelect.length) {
      excludedSelect.select2('destroy');
    }
  }
}

// Changed for a change event to occur when change a value in #issue_assigned_to_id.
// https://github.com/ishikawa999/redmine_searchable_selectbox/issues/6
function initAssignToMeLink() {
  $('form#issue-form .assign-to-me-link').click(function(event) {
    event.preventDefault();
    var element = $(event.target);
    $('#issue_assigned_to_id').val(element.data('id')).change();
    element.hide();
  });
}

// Bug handling: https://github.com/select2/select2/issues/1908
// Retrigger the change event only when there is a native event.
function retriggerChangeIfNativeEventExists(element) {
  // Rails.fire cannot be used in Redmine 3.x or earlier, so it will not be executed.
  if (element.data('use-add-change-event-listener') && typeof Rails != 'undefined') {
    Rails.fire(element[0], 'change')
  }
}