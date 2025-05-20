# frontend/main.py
#
#  Punto de arranque. Crea un ScreenManager e
#  inicializa la primera pantalla (WelcomeScreen).
#
from kivymd.app import MDApp
from kivy.lang     import Builder
from kivy.uix.screenmanager import ScreenManager

# Controladores de cada nueva pantalla
from frontend.screens.welcome_screen    import WelcomeScreen
from frontend.screens.choose_photo_screen import ChoosePhotoScreen
from frontend.screens.preview_screen      import PreviewScreen
from frontend.screens.loading_screen import LoadingScreen
from frontend.screens.result_screen import ResultScreen

class CataractApp(MDApp):

    def build(self):
        # 1) Cargamos todos los archivos .kv necesarios.
        Builder.load_file("kv/welcome_screen.kv")
        Builder.load_file("kv/choose_photo_screen.kv")
        Builder.load_file("frontend/kv/preview_screen.kv")
        Builder.load_file("frontend/kv/result_screen.kv")
        Builder.load_file("frontend/kv/loading_screen.kv")

        # 2) Creamos el gestor de pantallas.
        sm = ScreenManager()
        sm.add_widget(WelcomeScreen(name="welcome"))
        sm.add_widget(ChoosePhotoScreen(name="choose_photo"))
        sm.add_widget(PreviewScreen(name="preview"))
        sm.add_widget(ResultScreen(name="result"))
        sm.add_widget(LoadingScreen(name="loading"))

        # 3) Tema de la app (colores, tipografía).
        self.theme_cls.primary_palette   = "Blue"
        self.theme_cls.primary_hue       = "700"
        self.theme_cls.theme_style       = "Light"   # ó "Dark"
        self.theme_cls.font_styles["H1"] = ["Roboto", 48, False, 0.15]

        return sm


if __name__ == "__main__":
    CataractApp().run()
