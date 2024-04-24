local Translations = {
    error = {
        error_bull = '¡No pastoreaste a los toros!',
        error_dead = '¡Fuiste asesinado por los cazadores, no pudiste devolver los toros!',
        dead_bulls = '¡El toro ha sido matado!',
        lead_ranch = '¡Aléjate del rancho y busca una zona donde pastorearlos antes de entregarlos!',
        job_error = '¡Ya tienes el trabajo!',
        bull_already = '¡Los toros ya están pastando!',
        error_time = '¡No has estado pastoreando los toros el tiempo suficiente!',
        error_bullback = '¡No todos los toros han vuelto!',
        dead_bull = '¡Uno de los toros fue asesinado, no recibiste recompensa!'
        
      },
      success = {
        time_grazing = '¡Puedes entregar los toros en el punto de entrega!',
        success_bull = '¡Buen trabajo!',
        bull_grazing = '¡El toro está pastando!',
        bull_finish = '¡Los toros pueden ser devueltos!'
      },
      menu = {
        job_bull = 'Coger el trabajo de pastorear a los toros',
        job_back = 'Traer de vuelta los toros',
        job_shepherd = 'Pastor',
        lead_menu = 'Liderar',
        to_graze = 'Pastar',
        bull_stop = 'Detener',
        close_menu = 'Cerrar'
      },
      primary = {
      minutes_left = 'Minutos restantes: '
      }
      
}


Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
