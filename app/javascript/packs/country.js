window.addEventListener("load", function() {
  const inputElement = document.getElementById("restaurant_country");

  // ひらがなをカタカナに変換する関数
  function toKatakana(str) {
    return str.replace(/[\u3041-\u3096]/g, function(match) {
      return String.fromCharCode(match.charCodeAt(0) + 0x60);
    });
  }

  inputElement.addEventListener("keyup", (e) => {
    const input = toKatakana(document.getElementById("restaurant_country").value);
    const baseUrl = window.location.origin;

    fetch(`${baseUrl}/restaurants/search_country/?input=${input}`)
      .then(response => response.json())
      .then(data => {
        const countryNames = data.keyword;
        const searchResult = document.getElementById("search-result");
        searchResult.innerHTML = "";

        countryNames.forEach(function(country) {
          const parentsElement = document.createElement("div");
          const childElement = document.createElement("div");

          parentsElement.setAttribute("id", "parents");
          childElement.setAttribute("id", country.id);
          childElement.setAttribute("class", "child");

          parentsElement.appendChild(childElement);
          childElement.innerHTML = country.name;
          searchResult.appendChild(parentsElement);

          const clickElement = document.getElementById(country.id);
          clickElement.addEventListener("click", () => {
            document.getElementById("restaurant_country").value = clickElement.textContent;
            document.getElementById("restaurant_country_id").value = country.id;
            searchResult.innerHTML = "";
          });
        });
      })
      .catch(error => console.error("Error:", error));
  });
});
