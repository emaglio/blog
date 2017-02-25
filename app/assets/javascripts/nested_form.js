// ---------------------------------
// ---------- Nested Form Plugin ----------
// ---------------------------------
// Brief plugin description
// Using John Dugan's boilerplate: https://john-dugan.com/jquery-plugin-boilerplate-explained/
// ------------------------

;(function ( $, window, document, undefined ) {
  var pluginName = 'nestedForm';

  // Create the plugin constructor
  function Plugin ( element, options ) {
    this.element = element;

    this._name = pluginName;
    this._defaults = $.fn.nestedForm.defaults;

    this.options = $.extend( {}, this._defaults, options );

    this.init();
  }

  // Avoid Plugin.prototype conflicts
  $.extend(Plugin.prototype, {

    // Initialization logic
    init: function () {
      this.build();
      this.bindEvents();
      this.applySort();
    },

    // Remove plugin instance completely
    destroy: function() {
      this.unbindEvents();
      this.$element.removeData();
    },

    // Cache DOM nodes for performance
    build: function () {
      var plugin = this;

      plugin.$element = $(plugin.element);

      $.each(plugin._defaults, function(key, value) {
        option = plugin.$element.data(key);

        if (option !== undefined) {
          plugin.options[key] = option;
        }
      });

      plugin.$objects = {
        nested_wrapper: plugin.$element.find(this.options.wrapper),
        template: $('#nested-form-template-' + plugin.options.name).html()
      };
    },

    // Bind events that trigger methods
    bindEvents: function() {
      var plugin = this,
          event_click = 'click' + '.' + plugin._name;

      plugin.$element.on(event_click, this.options.addRow, function(event) {
        event.preventDefault();

        plugin.addRow.call(plugin);
      });

      plugin.$objects.nested_wrapper.on(event_click, this.options.removeRow, function(event) {
        event.preventDefault();

        plugin.removeRow.call(plugin, this);
      });
    },

    // Unbind events that trigger methods
    unbindEvents: function() {
      this.$element.off('.'+this._name);
    },

    // Apply jQuery UI sortable
    applySort: function() {
      this.$objects.nested_wrapper.sortable({
        items: this.options.row,
        axis: 'y',
        handle: this.options.sortHandle,
        opacity: 0.4,
        scroll: true,
        placeholder: 'uk-placeholder',
        start: function(event, ui) {
          ui.placeholder.height(ui.helper.outerHeight() - 2);

          elements = ui.helper.find('> *:visible');
          width = (elements.length - 1) * 5;
          $.each(elements, function(index, item) {
            width += $(item).outerWidth();
          });

          ui.placeholder.width(width - 2);
        }
      });
    },

    // Add a new row
    addRow: function() {
      var $template = $(_.template(this.$objects.template)());

      this.$objects.nested_wrapper.append($template);
    },

    // Remove row
    removeRow: function(element) {
      var $nestedRow = $(element).parent(this.options.row),
          $id = $nestedRow.find('[name*="[id]"]');

      if ($id.val() === '') {
        $nestedRow.remove();
      } else {
        $nestedRow.hide();
      }

      $nestedRow.find('[name*="[_destroy]"]').val('1');
    }

  });

  $.fn.nestedForm = function ( options ) {
    this.each(function() {
      if ( !$.data( this, 'plugin_' + pluginName ) ) {
        $.data( this, 'plugin_' + pluginName, new Plugin( this, options ) );
      }
    });

    return this;
  };

  $.fn.nestedForm.defaults = {
    name: '',
    wrapper: '.nested-form-wrapper',
    sortHandle: '.nested-form-sort-handle',
    row: '.nested-form-row',
    addRow: '.nested-form-add-row',
    removeRow: '.nested-form-remove-row'
  };

})( jQuery, window, document );