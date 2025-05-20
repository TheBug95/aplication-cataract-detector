# frontend/screens/choose_photo_screen.py
"""
Controlador de la pantalla de selección de imagen.
Permite al usuario tomar una foto o elegir una del álbum.
Por ahora solo dispara un toast; luego conectaremos la cámara
y la galería.
"""
from kivy.properties import StringProperty
from kivymd.uix.screen import MDScreen
from kivymd.toast      import toast

class ChoosePhotoScreen(MDScreen):
    """Pantalla donde el usuario elige o toma una fotografía."""
    selected_path = StringProperty("")

    def on_camera_button(self):
        """
        Callback al pulsar “Take Photo”.
        Aquí lanzaremos la cámara en la siguiente iteración.
        """
        toast("Botón ‘Take Photo’ pulsado")
        self.manager.get_screen("preview").image_source = self.selected_path
        self.manager.current = "preview"

    def on_gallery_button(self):
        """
        Callback al pulsar “Select from Gallery”.
        Aquí abriremos el selector de imágenes en la siguiente iteración.
        """
        toast("Botón ‘Select from Gallery’ pulsado")
        self.manager.get_screen("preview").image_source = self.selected_path
        self.manager.current = "preview"
