"""
Pantalla de carga con animación y cuenta atrás.
Simula el tiempo de procesado antes de pasar a ResultScreen.
"""
from kivy.clock          import Clock
from kivy.properties     import NumericProperty
from kivymd.uix.screen   import MDScreen

class LoadingScreen(MDScreen):
    # Segundos restantes de carga
    remaining_time = NumericProperty(0)

    def on_pre_enter(self):
        """
        Se ejecuta justo antes de que la pantalla aparezca.
        Iniciamos la cuenta atrás y el spinner.
        """
        # Duración de prueba (puedes ajustar)
        self.remaining_time = 5
        # Llamar a _update_time cada segundo
        Clock.schedule_interval(self._update_time, 1)

    def _update_time(self, dt):
        """
        Reduce remaining_time y, al llegar a 0,
        detiene el cronómetro y navega a ResultScreen.
        """
        if self.remaining_time <= 1:
            # Detener la llamada periódica
            Clock.unschedule(self._update_time)
            # Ir a ResultScreen
            self.manager.current = "result"
        else:
            # Restar un segundo
            self.remaining_time -= 1
