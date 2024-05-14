window.addEventListener('load', function() {
  const inputElement = document.getElementById("restaurant_country");
  inputElement.addEventListener('keyup', (e) => {
    const input = document.getElementById("restaurant_country").value;
    const baseUrl = window.location.origin;
    const xhr = new XMLHttpRequest();
    xhr.open("GET", `${baseUrl}/restaurants/search_country/?input=${input}`, true);
    xhr.responseType = "json";
    xhr.send();
    xhr.onload = () => {
      const countryName = xhr.response.keyword;
      const searchResult = document.getElementById('search-result');
      searchResult.innerHTML = '';
      countryName.forEach(function(country){
        const parentsElement = document.createElement('div');
        const childElement = document.createElement("div");

        parentsElement.setAttribute('id', 'parents');
        childElement.setAttribute('id', country.id);
        childElement.setAttribute('class', 'child');

        parentsElement.appendChild(childElement);
        childElement.innerHTML = country.name;
        searchResult.appendChild(parentsElement);

        const clickElement = document.getElementById(country.id);
        clickElement.addEventListener('click', () => {
          document.getElementById("restaurant_country").value = clickElement.textContent;
          document.getElementById("restaurant_country_id").value = country.id;

          countryName.forEach(function(c) {
            if (c.id !== country.id) {
              const el = document.getElementById(c.id);
              if (el) {
                el.remove();
                clickElement.remove();
              }
            }
          }) ;
        });
      });
    };
  });
});
