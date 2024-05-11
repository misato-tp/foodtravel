document.addEventListener('DOMContentLoaded', () => {
  const createImageHTML = (blob) => {
    const imageElement = document.getElementById('preview-image');
    const blobImage = document.createElement('img');
    blobImage.setAttribute('class', 'preview-img') 
    blobImage.setAttribute('src', blob);
    imageElement.appendChild(blobImage);
  };
  document.getElementById('report_image').addEventListener('change', (e) =>{
    const imageContent = document.querySelector('#preview-image img');
    if (imageContent){
      imageContent.remove();
    }
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    createImageHTML(blob);
  });
});
