document.addEventListener('DOMContentLoaded', () => {
  const createImageHTML = (blob) => {
    const imageElement = document.getElementById('preview-image');
    const blobImage = document.createElement('img');
    blobImage.setAttribute('class', 'preview-image');
    blobImage.setAttribute('src', blob);
    imageElement.appendChild(blobImage);
  };

  const restaurantImage = document.getElementById('restaurant_image');
  if (restaurantImage) {
    restaurantImage.addEventListener('change', (e) => {
      const imageContent = document.querySelector('img');
      if (imageContent) {
        imageContent.remove();
      }
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
    });
  }

  const reportImage = document.getElementById('report_image');
  if (reportImage) {
    reportImage.addEventListener('change', (e) => {
      const imageContent = document.querySelector('img');
      if (imageContent) {
        imageContent.remove();
      }
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
    });
  }
});
jQuery(document).on("turbolinks:load", function () {
  $('#restaurant_postal_code').jpostal({
    postcode: [
      '#restaunrant_postal_code'
    ],
    address: {
      '#restaurant_prefecture_code': '%3',
      '#restaurant_city': '%4',
      '#restaurant_street': '%5%6',
      '#restaurant_other_address': '%7'
    },
  })
})
