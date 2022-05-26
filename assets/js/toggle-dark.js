function toggleDarkTheme() {
    const body = document.body;
    body.classList.toggle("dark-mode");
    document.documentElement.classList.toggle("dark-mode");

    //If dark mode is selected
    if (body.classList.contains("dark-mode")) {
      //Save user preference in storage
      localStorage.setItem("dark-theme", "true");
      //If light mode is selected
    } else {
      body.classList.remove("dark-mode");
      document.documentElement.classList.remove("dark-mode");
      setTimeout(function () {
        localStorage.removeItem("dark-theme");
      }, 100);
    }
}




document.addEventListener( "DOMContentLoaded", () => {
    let checked = false
    if (localStorage.getItem("dark-theme")) {
        document.body.classList.add("dark-mode");
        document.documentElement.classList.add("dark-mode");
        checked = true;
    }
    let toggle_html = `    <input type="checkbox" id="theme-toggle" ${checked? "checked" : ""}/>
    <label for="theme-toggle"><span></span></label>`
    document.getElementById("dark-mode-widget").innerHTML = toggle_html;
    
    document.getElementById("theme-toggle").addEventListener('change', () => {
      console.log("change");
      toggleDarkTheme();
    })
})