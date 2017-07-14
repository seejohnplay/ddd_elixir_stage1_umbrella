import {Socket} from "phoenix"

class Tracking {

  static init() {
    let socket = new Socket("/socket", {params: {token: window.userToken}})

    socket.connect()

    let trackingInfo = document.getElementById("tracking-info")

    if (trackingInfo) {
      let trackingId = trackingInfo.getAttribute("tracking-id")
      let channel = socket.channel("tracking:" + trackingId, {})
      let nextEvent = document.getElementById("next-event")

      nextEvent.addEventListener("click", e => {
        channel.push("next_event", trackingId)
      })

      channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp, socket) })
        .receive("error", resp => { console.log("Unable to join", resp) })

      channel.on("next_event", handling_event => {
        let eventContainer = document.getElementById("handling-events")
        let template = document.createElement("tr")

        template.innerHTML = `
          <td>${handling_event.voyage}</td>
          <td>${handling_event.location}</td>
          <td>${handling_event.date}</td>
          <td>${handling_event.time}</td>
          <td>${handling_event.type}</td>
        `

        eventContainer.appendChild(template)

        let cargoStatusContainer = document.getElementById("cargo-status")

        cargoStatusContainer.innerHTML =
            handling_event.type === "LOAD" ? "ON BOARD" : "IN PORT"
      })
    }
  }
}

document.addEventListener("DOMContentLoaded", () => Tracking.init())

export default Tracking
