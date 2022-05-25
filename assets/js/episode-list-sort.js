export class Sorter {

    order = "new_first"

    constructor() {
        document.getElementById("order-select").addEventListener( 'change', () => {
            let element = document.getElementById("order-select");
            let op = element.options[element.selectedIndex].value;
            this.order = op;
            let localStorage = window.localStorage;
            localStorage.setItem("sort", this.order);
            this.sortData(op)
        } )
        let storage_sort = window.localStorage.getItem("sort");
        if (storage_sort != null)
        {
            this.order = storage_sort;
            this.sortData(this.order);
            let element = document.getElementById("order-select");
            element.value = this.order;
        }
    }

    comparator(a, b) {
        if (a.dataset.index < b.dataset.index)
            return 1;
        if (a.dataset.index > b.dataset.index)
            return -1;
        return 0;
    }
      
    // Function to sort Data
    sortData(order) {
        var indexes = document.querySelectorAll("[data-index]");
        var indexesArray = Array.from(indexes);
        let sorted = indexesArray.sort(this.comparator);

        if (this.order === "old_first")
            sorted = sorted.reverse()

        sorted.forEach(e =>
            document.querySelector("#episode-box").appendChild(e));
    }

};

new Sorter();
