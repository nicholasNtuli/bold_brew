import Cropper from "cropperjs"

document.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("profile-picture-input")
  const preview = document.getElementById("profile-picture-preview")
  const hiddenField = document.getElementById("cropped-image-data")
  let cropper

  if (input) {
    input.addEventListener("change", (event) => {
      const file = event.target.files[0]
      if (!file) return

      const reader = new FileReader()
      reader.onload = (e) => {
        preview.src = e.target.result
        preview.style.display = "block"

        if (cropper) {
          cropper.destroy()
        }
        cropper = new Cropper(preview, {
          aspectRatio: 1,
          viewMode: 1,
          autoCropArea: 1,
          crop(event) {
            const canvas = cropper.getCroppedCanvas()
            hiddenField.value = canvas.toDataURL("image/png")
          }
        })
      }
      reader.readAsDataURL(file)
    })
  }
})