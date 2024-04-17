// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap";
import "../stylesheets/application.scss";

Rails.start()
//Turbolinks.start()
ActiveStorage.start()

require('./preview')
require('./jquery.jpostal')

$(function(){
  $(document).on('turbolinks:load',() =>{
    $('#restaurant_postal_code').jpostal({
      postcode : [
        '#restaurant_postal_code'
      ],
      address: {
        "#restaurant_prefecture_code": "%3",
        "#restaurant_city"           : "%4%5",
        "#restaurant_street"         : "%6%7"
      }
    });
  });
});