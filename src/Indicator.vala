/*
 * Copyright (c) 2011-2018 elementary, Inc. (https://elementary.io)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 */

/**
 * This small example shows how to use the wingpanel api to create a simple indicator
 * and how to make use of some useful helper widgets.
 */
public class SugarMate.Indicator : Wingpanel.Indicator {

    private Gtk.Label display_widget;
    private Gtk.Label last_updated_label;
    private Gtk.Grid main_widget;
    private int64 blood_glucose;
    private string trend_symbol;
    private string last_updated;

    public Indicator () {
        /* Some information about the indicator */
        Object (
            code_name : "sugarmate-indicator", /* Unique name */
            display_name : _("SugarMate"), /* Localised name */
            description: _("Displays current blood sugar reading from sugarmate.io") /* Short description */
        );
    }

    construct {
        display_widget = new Gtk.Label (null);

        last_updated_label = new Gtk.Label (null);
        main_widget = new Gtk.Grid ();
        main_widget.add (last_updated_label);

        loadGlucose();

        Timeout.add ( 1000 * 60 * 1, () => {
            loadGlucose();
            return true;
        } );

        this.visible = true;
    }

    /* This method is called to get the widget that is displayed in the panel */
    public override Gtk.Widget get_display_widget () {
        return display_widget;
    }

    /* This method is called to get the widget that is displayed in the popover */
    public override Gtk.Widget? get_widget () {
        return main_widget;
    }

    /* This method is called when the indicator popover opened */
    public override void opened () {
        /* Use this method to get some extra information while displaying the indicator */
    }

    /* This method is called when the indicator popover closed */
    public override void closed () {
        /* Your stuff isn't shown anymore, now you can free some RAM, stop timers or anything else... */
    }

    private void loadGlucose() {
        critical ("Running loadGlucose");
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", "https://sugarmate.io/api/v1/ksk48c/latest.json");
        // send the HTTP request and wait for response
        session.send_message (message);
        try {
            var parser = new Json.Parser ();
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);

            var root_object = parser.get_root ().get_object ();
            blood_glucose = root_object.get_int_member ("value");
            trend_symbol = root_object.get_string_member ("trend_symbol");
            last_updated = root_object.get_string_member ("time");

            display_widget.label = blood_glucose.to_string () + "  " + trend_symbol;
            last_updated_label.label = "Last Updated: " + last_updated;
        } catch (Error e) {
            critical ("I guess something is not working...\n");
        }
    }
}

/*
 * This method is called once after your plugin has been loaded.
 * Create and return your indicator here if it should be displayed on the current server.
 */
public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    /* A small message for debugging reasons */
    debug ("Activating Sample Indicator");

    /* Check which server has loaded the plugin */
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        /* We want to display our sample indicator only in the "normal" session, not on the login screen, so stop here! */
        return null;
    }

    /* Create the indicator */
    var indicator = new SugarMate.Indicator ();

    /* Return the newly created indicator */
    return indicator;
}
