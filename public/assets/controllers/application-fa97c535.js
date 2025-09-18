import { Application } from "@hotwired/stimulus"
import "./controllers/profile_picture_cropper"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
