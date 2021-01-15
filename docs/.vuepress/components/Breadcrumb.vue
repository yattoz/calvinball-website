<template>

 <ul class="breadcrumb">
  <li><a href="#">Home ></a></li>
  <li><a href="#">Pictures ></a></li>
  <li><a href="#">Summer 15 ></a></li>
  <li>Italy</li>
</ul> 
</template>

<script>
export default {
  mounted() {
    let breadcrumb = document.querySelector(".breadcrumb")
    let li = document.createElement('li')
    let a = document.createElement('a')
    a.innerHTML = "LOL"
    a.href = "/"
    li.appendChild(a)
    breadcrumb.appendChild(li)
  },
  computed: {

  }
}
</script>

<style scoped>
 /* Style the list */
.breadcrumb {
  padding: 10px 16px;
  list-style: none;
}

/* Display list items side by side */
li {
  display: inline;
  font-size: 18px;
}

/* Add a slash symbol (/) before/behind each list item */
 li+li:before {
  padding: 8px;
  color: black;
  content: "/\00a0";
}

/* Add a color to all links inside the list */
li a {
  color: #0275d8;
  text-decoration: none;
}

/* Add a color on mouse-over */
li a:hover {
  color: #01447e;
  text-decoration: underline;
} 
</style>