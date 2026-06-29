import { Controller } from "@hotwire/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { showId: Number }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ShowChannel", room: `show_${this.showIdValue}_channel` },
      {
        received: (data) => {
          this.handleSeatUpdate(data)
        }
      }
    )
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  handleSeatUpdate(data) {
    const seatElement = document.getElementById(`seat_${data.seat_id}`)
    if (!seatElement) return

    if (data.action === "released") {
      seatElement.style.background = ""
      
      seatElement.innerHTML = `
        <small>${seatElement.dataset.row}${seatElement.dataset.number}</small><br>
        <input type="checkbox" name="seat_ids[]" value="${data.seat_id}" id="check_seat_${data.seat_id}">
      `
    } else if (data.action === "locked") {
      seatElement.style.background = "#ffcccc"
      seatElement.innerHTML = `
        <small>${seatElement.dataset.row}${seatElement.dataset.number}</small><br>
        <span style="color: orange; font-size: 11px;">Locked</span>
      `
    }
  }
}