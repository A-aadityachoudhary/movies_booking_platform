import { createConsumer } from "@rails/actioncable"

  const LOCK_DURATION_MS = 60 * 1000;
  const seatTimers = {};

  function paintSeat(wrapper, checkbox, status, lockedById, currentUserId) {
    if (!wrapper || !checkbox) return;

    if (status === "booked") {
      checkbox.checked = false;
      checkbox.disabled = true;
      wrapper.style.background = "rgba(15, 23, 42, 0.6)";
      wrapper.style.borderColor = "rgba(255, 255, 255, 0.05)";
      wrapper.style.color = "rgba(255, 255, 255, 0.2)";
      wrapper.style.cursor = "not-allowed";
      wrapper.style.textDecoration = "line-through";
      wrapper.style.transform = "none";
      wrapper.innerHTML = "X";
    } else if (status === "locked") {
      if (String(lockedById) !== String(currentUserId)) {
        checkbox.checked = false;
        checkbox.disabled = true;
        wrapper.style.background = "rgba(15, 23, 42, 0.6)";
        wrapper.style.borderColor = "rgba(255, 255, 255, 0.05)";
        wrapper.style.color = "rgba(253, 186, 116, 0.4)";
        wrapper.style.cursor = "not-allowed";
        wrapper.style.textDecoration = "none";
        wrapper.style.transform = "none";
        wrapper.innerHTML = "🔒";
      } else {
        checkbox.disabled = false;
        checkbox.checked = true;
        wrapper.style.background = "#ffffff";
        wrapper.style.color = "#0f172a";
        wrapper.style.borderColor = "#ffffff";
        wrapper.style.cursor = "pointer";
        wrapper.style.textDecoration = "none";
        wrapper.style.transform = "scale(0.9)";
        wrapper.innerHTML = wrapper.dataset.seatLabel;
      }
    } else if (status === "available") {
      checkbox.checked = false;
      checkbox.disabled = false;
      wrapper.style.background = "rgba(255, 255, 255, 0.1)";
      wrapper.style.borderColor = "rgba(255, 255, 255, 0.2)";
      wrapper.style.color = "#ffffff";
      wrapper.style.cursor = "pointer";
      wrapper.style.textDecoration = "none";
      wrapper.style.transform = "none";
      wrapper.innerHTML = wrapper.dataset.seatLabel;
    }
  }

  function scheduleClientRelease(seatId, lockedAt, wrapper, checkbox, currentUserId) {
    clearTimeout(seatTimers[seatId]);
    const remaining = LOCK_DURATION_MS - (Date.now() - new Date(lockedAt).getTime());
    if (remaining <= 0) {
      paintSeat(wrapper, checkbox, "available", null, currentUserId);
      return;
    }
    seatTimers[seatId] = setTimeout(() => {
      paintSeat(wrapper, checkbox, "available", null, currentUserId);
      delete seatTimers[seatId];
    }, remaining);
  }

  function clearSeatTimer(seatId) {
    clearTimeout(seatTimers[seatId]);
    delete seatTimers[seatId];
  }

  // Setup execution block
  const seatContainer = document.getElementById("seating-chart-deck");
  if (seatContainer) {
    const showId = seatContainer.dataset.showtimeId;
    const currentUserId = seatContainer.dataset.currentUserId;
    const consumer = createConsumer();

    // Re-sync existing lock countdown items
    seatContainer.querySelectorAll('[data-locked-at]').forEach((wrapper) => {
      const lockedAt = wrapper.dataset.lockedAt;
      if (!lockedAt) return;
      const seatId = wrapper.id.replace("seat_wrapper_", "");
      const checkbox = document.getElementById(`checkbox_${seatId}`);
      scheduleClientRelease(seatId, lockedAt, wrapper, checkbox, currentUserId);
    });

    const showChannel = consumer.subscriptions.create(
      { channel: "ShowChannel", show_id: showId },
      {
        received(data) {
          console.log("WebSocket Broadcast Received:", data); // Check your browser developer console for this!
          const seatId = String(data.showtime_seat_id);
          const wrapper = document.getElementById(`seat_wrapper_${seatId}`);
          const checkbox = document.getElementById(`checkbox_${seatId}`);
          if (!wrapper || !checkbox) return;

          if (data.action === "seat_updated" && data.status) {
            if (data.status === "locked") {
              paintSeat(wrapper, checkbox, "locked", data.locked_by_id, currentUserId);
              if (data.locked_at) {
                scheduleClientRelease(seatId, data.locked_at, wrapper, checkbox, currentUserId);
              }
            } else {
              clearSeatTimer(seatId);
              paintSeat(wrapper, checkbox, data.status, data.locked_by_id, currentUserId);
            }
          } else if (data.action === "lock_failed" && String(data.user_id) === String(currentUserId)) {
            clearSeatTimer(seatId);
            paintSeat(wrapper, checkbox, "locked", "__other__", currentUserId);
            alert("Sorry! Another user grabbed this seat just before your click registered.");
          }
        },

        toggleSeat(showtimeSeatId, isSelected) {
          this.perform("toggle_seat", { showtime_seat_id: showtimeSeatId, selected: isSelected });
        }
      }
    );

    // Watch for click adjustments 
    seatContainer.addEventListener("change", (event) => {
      if (event.target.matches("input[name='seat_ids[]']")) {
        const checkbox = event.target;
        const seatId = checkbox.value;
        const wrapper = document.getElementById(`seat_wrapper_${seatId}`);
        
        // Optimistically change style locally for instant visual feedback
        if (checkbox.checked) {
          paintSeat(wrapper, checkbox, "locked", currentUserId, currentUserId);
        } else {
          paintSeat(wrapper, checkbox, "available", null, currentUserId);
        }

        // Fire request to the Rails server terminal logs via the ActionCable pipe
        showChannel.toggleSeat(checkbox.value, checkbox.checked);
      }
    });

    document.addEventListener("turbo:before-visit", () => {
      Object.keys(seatTimers).forEach(clearSeatTimer);
      showChannel.unsubscribe();
    }, { once: true });
  }

