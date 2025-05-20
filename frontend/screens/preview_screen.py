"""
Controlador de la pantalla de previsualización de la foto.
Muestra la imagen elegida y dos botones: “Analyze” y “Retake”.
"""
from kivymd.uix.screen import MDScreen
from kivymd.toast      import toast
from kivy.properties   import StringProperty

class PreviewScreen(MDScreen):
    """
    La propiedad `image_source` almacenará la ruta
    de la imagen a mostrar.
    """
    image_source = StringProperty("")

    def on_analyze_button(self):
        """
        Ahora asignamos la imagen y el texto al ResultScreen
        y navegamos a ella.
        """
        toast("Analyze pulsado")
        # obtenemos instancias
        preview = self
        result  = self.manager.get_screen("result")

        # 1) ruta de la imagen segmentada (por ahora usamos la misma preview)
        result.image_source = preview.image_source

        # 2) texto de diagnóstico stub (en futuro vendrá del backend)
        # Puedes cambiar aquí según la inferencia real:
        result.result_text = "Cataract Detected"

        # 3) navegar a LoadingScreen
        self.manager.current = "loading"

    def on_retake_button(self):
        """
        Callback de “Retake”. Volvemos a ChoosePhotoScreen.
        """
        toast("Retake pulsado")
        self.manager.current = "choose_photo"
