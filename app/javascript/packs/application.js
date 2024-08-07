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
import Raty from './raty.js';
import "@fortawesome/fontawesome-free/js/all";

Rails.start()
Turbolinks.start()
ActiveStorage.start()


  $(document).on('turbolinks:load', function (){
    $('#restaurant_postal_code.form-control').jpostal({
      postcode : [
        '#restaurant_postal_code.form-control'
      ],
      address: {
        "#restaurant_address.form-control": "%3%4%5%6%7"
      }
    });
  });

  window.raty = function(elem,opt) {
    let raty = new Raty(elem,opt)
    raty.init();
    return raty;
  }
