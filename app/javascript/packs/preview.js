document.addEventListener('DOMContentLoaded', () => {
  const createImageHTML = (blob) => {
    const imageElement = document.getElementById('preview-image');
    const blobImage = document.createElement('img');
    blobImage.setAttribute('class', 'preview-img') 
    blobImage.setAttribute('src', blob);
    imageElement.appendChild(blobImage);
  };
  const reportImageElement = document.getElementById('report_image');
  if (reportImageElement) {
  reportImageElement.addEventListener('change', (e) =>{
    const imageContent = document.querySelector('#preview-image img');
    if (imageContent){
      imageContent.remove();
    }
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    createImageHTML(blob);
  });
}
const restaurantImageElement = document.getElementById('restaurant_image');
if (restaurantImageElement) {
  restaurantImageElement.addEventListener('change', (e) =>{
    const imageContent = document.querySelector('#preview-image img');
    if (imageContent) {
      imageContent.remove();
    }
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    createImageHTML(blob);
  });
}
const userImageElement = document.getElementById('user_profile_image');
if (userImageElement) {
  userImageElement.addEventListener('change', (e) =>{
    const imageContent = document.querySelector('#preview-image img');
    if (imageContent) {
      imageContent.remove();
    }
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    createImageHTML(blob);
  });
}
});
