import {Socket} from "phoenix"

const H_E_COLOR = 52

class Tracking {

  static init() {
    // Create and connect to a web socket monitored by the shipping web server
    let socket = new Socket("/socket", {params: {token: window.userToken}})
    socket.connect()

    // If we are on the page that tracks a cargo's status, set up to
    // join and receive messages for this particular tracking id.
    let trackingInfo = document.getElementById("tracking-info")
    if (trackingInfo) {
      let trackingId = trackingInfo.getAttribute("tracking-id")
      let channel = socket.channel("tracking:" + trackingId, {})

      channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp, socket) })
        .receive("error", resp => { console.log("Unable to join", resp) })

      // Listen for new_handling_event messages. The payload contains info about the
      // handling event
      channel.on("new_handling_event", handling_event => {
        let eventContainer = document.getElementById("handling-events")
        let template = document.createElement("tr")

        template.innerHTML = `
          <td>${handling_event.voyage}</td>
          <td>${handling_event.location}</td>
          <td>${handling_event.date}</td>
          <td>${handling_event.time}</td>
          <td>${handling_event.type}</td>
        `
        // Prepend the new handling event to the existing list
        eventContainer.insertBefore(template, eventContainer.firstChild)

        // Highlight the new event and then fade away...
        template.style.backgroundColor = 'hsl(' + H_E_COLOR + ', 100%, 70%)';
        var d = 1000;
        for (var i=70; i <= 100; i += 0.1) {
          d += 10;
          (function(ii, dd) {
            setTimeout(function(){
              var next_color = 'hsl(' + H_E_COLOR + ', 100%, ' + ii + '%)';
              template.style.background = next_color
            }, dd);
          })(i, d);
        }

        let cargoStatusContainer = document.getElementById("cargo-status")

        cargoStatusContainer.innerHTML =
            handling_event.type === "LOAD" ? "ON BOARD" : "IN PORT"
      })
    }
  }
}

document.addEventListener("DOMContentLoaded", () => Tracking.init())

export default Tracking
