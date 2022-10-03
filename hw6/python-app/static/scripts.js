const IPINFO_TOKEN = "76425a4da47e80";
const GEOCODE_API = "AIzaSyCtVyR8_f2pS9QfSdOFLhTNqLwtBXI10Xw";
var auto_detect = false;
var table, headers, directions;
const disableField = (idName) => {
    doc = document.getElementById(idName);
    checkbox = document.getElementById("auto-detect");
    if (checkbox.checked) {
        doc.value = "";
        doc.disabled = true;
        auto_detect = true;
    }
    if (!checkbox.checked) {
        doc.disabled = false;
        auto_detect = false;
    }
}
const handleErrors = async (response) => {
    if (!response.ok) {
        const message = await response.json();
        alert(message.message);
        // console.log("message", message);

        throw Error(message);
    }
    return response.json();
}
const processForm = async (event) => {
    event.preventDefault();
    const form = document.getElementById("search_form");
    var form_data = new FormData(form);
    var keyword = form_data.get("keyword");
    keyword = keyword.split(" ");
    keyword = keyword.join("+");
    var categories = document.getElementById("category").value;
    var radius = form_data.get("radius");
    radius = radius == "" ? 10 : radius;
    var latitude = "";
    var longitude = "";
    if (auto_detect) {
        url = "https://ipinfo.io/?token=" + IPINFO_TOKEN;
        await fetch(url, {
            method: 'GET',
            mode: 'cors',
        })
            .then(handleErrors)
            .then(data => {
                location = data["loc"];
                loc = location.split(",");
                latitude = loc[0];
                longitude = loc[1];
                // console.log(typeof latitude);
            })
            .catch(function (error) {
                console.log(error)
            })

    }
    else {
        var location = form_data.get("location");
        location = location.split(" ");
        location = location.join("+");
        url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + location + "&key=" + GEOCODE_API;
        await fetch(url, {
            method: 'GET',
            mode: 'cors',
        })
            .then(handleErrors)
            .then(data => {
                loc = data.results[0].geometry.location;
                latitude = loc["lat"];
                longitude = loc["lng"];
            })
            .catch(function (error) {
                console.log(error)
            })
    }
    search_url = "business_search?keyword=" + keyword + "&latitude=" + latitude + "&longitude=" + longitude + "&categories=" + categories + "&radius=" + radius;
    await fetch(search_url, {
        method: 'GET',
    })
        .then(handleErrors)
        .then(data => {
            displayData(event, data);
        })
        .catch(function (error) {
            console.log(error)
        })

}
const displayData = (event, data) => {
    event.preventDefault();
    doc = document.getElementById("results");
    doc.innerHTML = "";
    // console.log(data.total);
    if (data.total > 0) {
        // console.log(data);
        table = document.createElement('table');
        table.className = "table_card";
        table.id = "results_table"
        table_body = document.createElement("tbody");
        thead = document.createElement("thead");
        thead.className = "table_header";
        head_tr = document.createElement("tr");
        columns = ["No.", "Image", "Business Name", "Rating", "Distance (miles)"];
        for (i = 0; i < columns.length; i++) {
            element = document.createElement("th");
            element.textContent = columns[i];
            if (columns[i] == "Rating") {
                element.style.width = "20%";
                element.style.cursor = "pointer";
                element.setAttribute("data-type", "number");
                element.setAttribute("onclick", "sortTable(3)");
            }
            if (columns[i] == "Distance (miles)") {
                element.style.width = "20%";
                element.style.cursor = "pointer";
                element.setAttribute("data-type", "number");
                element.setAttribute("onclick", "sortTable(4)");
            }
            if (columns[i] == "Image") {
                element.style.width = "10%";
            }
            if (columns[i] == "Business Name") {
                element.style.width = "50%";
                element.style.cursor = "pointer";
                element.setAttribute("data-type", "string");
                element.setAttribute("onclick", "sortTable(2)");
            }
            head_tr.appendChild(element);
        }
        thead.appendChild(head_tr);
        table.appendChild(thead);
        for (i = 0; i < data.businesses.length; i++) {
            tr = document.createElement("tr");
            no_td = document.createElement("td");
            no_td.textContent = i + 1;
            img_td = document.createElement("td");
            img_tag = document.createElement("img");
            src = data.businesses[i].image_url;
            if (src == "") {
                img_tag.src = "/static/yelp.png"
            }
            else {
                img_tag.src = src
            }
            // img_td.style.width = "10%";
            img_td.appendChild(img_tag);
            business_td = document.createElement("td");
            busi_name = document.createElement("span");
            busi_name.id ="business_name";
            busi_name.textContent = data.businesses[i].name;
            business_td.appendChild(busi_name);
            function_name = "getBusinessInfo('" + data.businesses[i].id + "')";
            business_td.setAttribute("onclick", function_name);
            business_td.style.cursor = "pointer";
            // business_td.style.width = "40%"
            rating_td = document.createElement("td");
            rating_td.textContent = data.businesses[i].rating;
            dis = data.businesses[i].distance;
            dis = dis / 1609.344;
            dis = parseFloat(dis).toFixed(2);
            distance_td = document.createElement("td");
            distance_td.textContent = dis;
            tr.appendChild(no_td);
            tr.appendChild(img_td);
            tr.appendChild(business_td);
            tr.appendChild(rating_td)
            tr.appendChild(distance_td);
            table_body.appendChild(tr);

        }
        table.appendChild(table_body);
        doc.appendChild(table);
        doc.scrollIntoView();
    }
    else {
        // alert("in");
        error_div = document.createElement('div');
        error_div.className = "error_card"
        text = document.createTextNode("No record has been found");
        error_div.appendChild(text);
        doc.appendChild(error_div);
    }
    table = document.getElementById("results_table");
    headers = table.querySelectorAll("th");
    directions = Array.from(headers).map(function (header) { return ''; });
}
// Referenced from https://htmldom.dev/sort-a-table-by-clicking-its-headers/
const sortTable = function (index) {
    const tableBody = document.querySelector('tbody');
    const rows = tableBody.querySelectorAll('tr');
    const newRows = Array.from(rows);
    const direction = directions[index] || 'asc';
    const multiplier = (direction == 'asc') ? 1 : -1;

    newRows.sort(function (rowA, rowB) {
        const cellA = rowA.querySelectorAll('td')[index].innerHTML;
        const cellB = rowB.querySelectorAll('td')[index].innerHTML;

        const a = transform(index, cellA);
        const b = transform(index, cellB);

        switch (true) {
            case a > b:
                return 1 * multiplier;
            case a < b:
                return -1 * multiplier;
            case a == b:
                return 0;
        }
    });
    [].forEach.call(rows, function (row) {
        tableBody.removeChild(row);
    })
    for (i = 0; i < newRows.length; i++) {
        newRows[i].querySelectorAll('td')[0].innerHTML = i + 1;
        tableBody.appendChild(newRows[i]);
    }
    directions[index] = direction === 'asc' ? 'desc' : 'asc';


};
const transform = (index, content) => {
    const type = headers[index].getAttribute('data-type');
    switch (type) {
        case 'number':
            return parseFloat(content);
        case 'string':
        default:
            return content;
    }
};
const getBusinessInfo = async (id) => {
    const doc = document.getElementById('business');
    doc.innerHTML = "";
    var result;
    search_url = "business_info?business_id=" + id;
    await fetch(search_url, {
        method: 'GET',
    })
        .then(handleErrors)
        .then(data => {
            result = data;
        })
        .catch(function (error) {
            console.log(error)
        })
    div = document.createElement("div");
    div.id = "business_card";

    header_name = document.createElement("h1");
    header_name.textContent = result.name;
    header_name.style.textAlign = "center";
    header_name.style.marginBottom = "0";

    hr = document.createElement("hr");
    // Status -> result.hours[0].is_open_now
    // Category -> result.categories[x].title 
    // Address -> result.location.display_address
    // Phone Number -> result.display_phone
    // Transaction Supported -> result.transactions (array)
    // Price -> result.price
    //  More Info -> result.url
    // Photos -> result.photos (array of 3)
    columns = ["Status", "Category", "Address", "Phone Number", "Transaction Supported", "Price", "More info"]


    div.appendChild(header_name);
    div.appendChild(hr);
    sections = [];
    for (i = 0; i < columns.length; i++) {
        section = document.createElement("section");
        section.style.height = "90px";
        header = document.createElement("h2");
        paragraph = status_paragraph = document.createElement("p");
        paragraph.style.fontSize = "12.5px";
        if (columns[i] == "Status") {
            if (result.hasOwnProperty("hours") && result.hours[0].is_open_now != null) {
                header.textContent = "Status";
                paragraph.textContent = result.hours[0].is_open_now ? "Open Now" : "Closed";
                paragraph.style.padding = "8px";
                paragraph.style.backgroundColor = result.hours[0].is_open_now ? "green" : "red";
                paragraph.style.width = "60px";
                paragraph.style.textAlign = "center";
                paragraph.style.borderRadius = "12px";
                section.appendChild(header);
                section.appendChild(paragraph);
                sections.push(section);
            }
            else {
                continue;
            }
        }
        else if (columns[i] == "Category") {
            if (result.hasOwnProperty("categories") && result.categories != null && result.categories.length > 0) {
                header.textContent = "Category";
                text = [];
                result.categories.forEach(element => text.push(element['title']));
                content = text.join(" | ");
                paragraph.textContent = content;
                section.appendChild(header);
                section.appendChild(paragraph);
                sections.push(section);
            }
            else {
                continue;
            }
        }
        else if (columns[i] == "Address") {
            if (result.hasOwnProperty("location")) {
                header.textContent = "Address";
                text = result.location.display_address.join(" ");
                paragraph.textContent = text;
                section.appendChild(header);
                section.appendChild(paragraph);
                sections.push(section);
            } else {
                continue;
            }
        }
        else if (columns[i] == "Phone Number") {
            if (result.hasOwnProperty("display_phone") && result.display_phone != "") {
                header.textContent = "Phone Number";
                paragraph.textContent = result.display_phone;
                section.appendChild(header);
                section.appendChild(paragraph);
                sections.push(section);
            }
            else {
                continue;
            }
        }
        else if (columns[i] == "Transaction Supported") {
            if (result.hasOwnProperty("transactions") && result.transactions != null && result.transactions.length > 0) {
                header.textContent = "Transactions Supported";
                x = result.transactions.map(function (e) {
                    e = e.charAt(0).toUpperCase() + e.slice(1);
                    return e;
                });
                content = x.join(" | ");
                paragraph.textContent = content;
                section.appendChild(header);
                section.appendChild(paragraph);
                sections.push(section);
            }
            else {
                continue;
            }
        }
        else if (columns[i] == "Price") {
            if (result.hasOwnProperty("price") && result.price != "") {
                header.textContent = "Price";
                paragraph.textContent = result.price;
                section.appendChild(header);
                section.appendChild(paragraph);
                sections.push(section);
            }
            else {
                continue;
            }
        }
        else if (columns[i] == "More info") {
            if (result.hasOwnProperty("url") && result.url != "") {
                header.textContent = "More info";
                // <p><a href="url" target="_blank">Yelp</a><p>
                anchor = document.createElement("a");
                anchor.textContent = "Yelp"
                anchor.setAttribute("href", result.url);
                anchor.setAttribute("target", "_blank");
                paragraph.appendChild(anchor);
                section.appendChild(header);
                section.appendChild(paragraph);
                sections.push(section);

            }
            else {
                continue;
            }
        }
    }
    var j = 0;
    outer_div = document.createElement("div");
    outer_div.style.height = "360px";
    left_div = document.createElement("div");
    right_div = document.createElement("div");
    for (j = 0; j + 1 < sections.length; j = j + 2) {
        left_div.appendChild(sections[j]);
        right_div.appendChild(sections[j + 1]);
        // div.appendChild(inside_div);
    }
    if (sections.length % 2 != 0) {
        left_div.appendChild(sections[j]);
    }
    left_div.style.display = "grid";
    right_div.style.display = "grid";
    left_div.style.float = "left";
    right_div.style.float = "right";
    right_div.style.marginRight = "90px"
    outer_div.appendChild(left_div);
    outer_div.appendChild(right_div);
    div.appendChild(outer_div);
    if (result.hasOwnProperty("photos")) {
        photo_grid = document.createElement("div");
        photo_grid.className = "photo_row";
        for (i = 0; i < result.photos.length; i++) {
            column = document.createElement("div");
            column.className = "photo_column";
            column.style.textAlign = "center";
            img = document.createElement("img");
            img.src = result.photos[i];
            span = document.createElement("div");
            span.textContent = "Photo " + (i + 1);
            column.appendChild(img);
            column.appendChild(span);
            photo_grid.appendChild(column);
        }
        div.appendChild(photo_grid);

    }


    doc.appendChild(div);
    doc.scrollIntoView();
}
const clear_data = () => {
    document.getElementById("results").innerHTML = "";
    document.getElementById("business").innerHTML = "";
}