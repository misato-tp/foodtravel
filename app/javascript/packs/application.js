// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "bootstrap"
import "../stylesheets/application.scss"
import "./preview"
import "./jquery.jpostal.js"
import "./country.js"
import "./flash_messages.js"
import "@fortawesome/fontawesome-free/js/all"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


  $(document).on('turbolinks:load', function (){
    $('#restaurant_postal_code.form_control').jpostal({
      postcode : [
        '#restaurant_postal_code.form_control'
      ],
      address: {
        "#restaurant_address.form_control": "%3%4%5%6%7"
      }
    });
  });
