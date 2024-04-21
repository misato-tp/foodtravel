if (location.pathname.match(/restaurants\/new|restaurants\/edit/)){
  window.addEventListener("load", (e) => {
    const inputElement = document.getElementById("restaurant_country");
    inputElement.addEventListener('keyup', (e) => {
      const input = document.getElementById("restaurant_country").value;
      const xhr = new XMLHttpRequest();
      xhr.open("GET", `search/?input=${input}`, true);
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
            clickElement.remove();
          });
        });
      };
    });
  });
};
