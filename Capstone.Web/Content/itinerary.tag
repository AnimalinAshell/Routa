﻿<itinerary>

    <div class="itineraryContainer">
        <form action="" method="post">
            <input class="itineraryName" value="{itinerary.ItinName}" type="text" placeholder="Itinerary Name" name="ItinName" />
            <input class="itineraryDate" value="{itinerary.StartDate}" type="date" placeholder="Itinerary Date" name="itineraryDate" />
        </form>
        <button class="saveButton" onclick={ save }>Save Itinerary</button>
        <button class="deleteButton">Delete Itinerary</button>
        <div id="sortable">
            <div each={stop, index in itinerary.Stops} class="itineraryList">
                <input name="position" type="hidden" value="{index}" />
                <p class="landmarkName">{stop.Name}</p>
                <input type="hidden" name="placeId" value="{stop.PlaceId}" />
                <button class="removeButton" onclick={remove}>Remove</button>

            </div>
        </div>

        <!--<ul id="sortable">
            <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 1</li>
            <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 2</li>
            <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 3</li>
            <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 4</li>
            <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 5</li>
            <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 6</li>
            <li class="ui-state-default"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>Item 7</li>
        </ul>-->

    </div>



    <script>




        this.itinerary = {
            ItinId: 0,
            ItinName: "ItinName",
            StartDate: '4/16/2018',
            Stops: []
        };

        this.on("mount", () => {



            if (this.opts.id != undefined) {
                fetch(`http://localhost:55900/api/itinerary/${this.opts.id}`, {
                    method: 'GET',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    credentials: 'include',
                })
                    .then(response => response.json())
                    .then(json => {
                        this.itinerary = json;
                        this.itinerary.StartDate = new Date(this.itinerary.StartDate).yyyymmdd();
                        this.update();

                        $("#sortable").sortable({
                            update: (event, ui) => {
                                // Create a new array temp
                                const temp = [];

                                // Loop through the DOM elements
                                const inputs = document.querySelectorAll("input[name=position]")
                                // For each element
                                for (let i = 0; i < inputs.length; i++) {
                                    // find its associated stop in the stops aray
                                    const newIndex = i;
                                    const oldIndex = inputs[i].value;
                                    console.log(`OLD: ${oldIndex} - NEW ${newIndex}`);

                                    temp[newIndex] = this.itinerary.Stops[oldIndex];
                                    // Add it to the temp array
                                }

                                // Assign temp to the itinerary stops
                                this.itinerary.Stops = temp;

                                console.log(this.itinerary.Stops);
                            }
                        });
                        $("#sortable").disableSelection();

                    });
            }
        })



        this.opts.bus.on('addPlace', data => {

            const stop = {
                PlaceId: data.place.place_id,
                Name: data.place.name,
                Address: data.place.formatted_address,
                Category: data.place.types[0],
                Latitude: data.place.geometry.location.lat(),
                Longitude: data.place.geometry.location.lng()


            };


            this.itinerary.Stops.push(stop);
            this.update();
        });

        this.save = (event) => {



            for (let i = 0; i < this.itinerary.Stops.length; i++) {

                this.itinerary.Stops[i].Order = i + 1;
            }
            this.itinerary.ItinName = document.querySelector("input[name=ItinName]").value;
            this.itinerary.StartDate = document.querySelector("input[name=itineraryDate]").value;
            console.log(this.itinerary);

            fetch('http://localhost:55900/api/itinerary', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                credentials: 'include',
                body: JSON.stringify(this.itinerary)
            }).then(response => response.json())
                .then(json => {
                    this.itinerary.ItinId = json.ItinId
                });

        }

        this.remove = function (event) {
            let toBeRemoved = event.item;

            let index = this.itinerary.Stops.map(m => m.name).indexOf(toBeRemoved.Name);

            this.itinerary.Stops.splice(index, 1);
        }


        Date.prototype.yyyymmdd = function () {

            var yyyy = this.getFullYear().toString();
            var mm = (this.getMonth() + 1).toString(); // getMonth() is zero-based
            var dd = this.getDate().toString();

            return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]);
        };

    </script>

</itinerary>
