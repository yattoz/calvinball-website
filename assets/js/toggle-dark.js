function toggleDarkTheme() {
    const body = document.body;
    body.classList.toggle("dark-mode");
    //If dark mode is selected
    if (body.classList.contains("dark-mode")) {
      //Save user preference in storage
      localStorage.setItem("dark-theme", "true");
      //If light mode is selected
    } else {
      body.classList.remove("dark-mode");
      setTimeout(function () {
        localStorage.removeItem("dark-theme");
      }, 100);
    }
}

document.getElementById("theme-toggle").addEventListener('change', () => {
    console.log("change");
    toggleDarkTheme();
})

document.addEventListener( "DOMContentLoaded", () => {
    if (localStorage.getItem("dark-theme")) {
        document.body.classList.add("dark-mode");
        document.getElementById("theme-toggle").checked = true;
      }
})