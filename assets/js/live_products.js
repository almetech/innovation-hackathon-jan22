import socket from "./user_socket"

let channel = socket.channel("products:lobby", {})

channel.join()
  .receive("ok", resp => { console.log("Joined products channel successfully", resp) })
  .receive("error", resp => { console.log("Unable to join products channel", resp) })

channel.on("new_msg", payload => {
  console.log(payload)
  let lot_size_el = document.getElementById(`${payload.product_id}-lot-size`)
  let demand_el = document.getElementById(`${payload.product_id}-demand`)
  lot_size_el.innerHTML = payload.lot_size
  demand_el.innerHTML = payload.demand_daily
})

