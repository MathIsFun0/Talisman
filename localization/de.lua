-- translated by Avery (onichama)
return {
        descriptions = {
                Mod = { 
                        Talisman = {
                                name = "Talisman",
                                text = {"Ein Mod, der das Punktelimit von Balatro erhöht", 
					                    "und Punktewertung-Animationen überspringt."},
                        }
                }
        }, 
        test = "j",
        talisman_vanilla = 'Vanilla (e308)',
        talisman_bignum = 'BigNum (ee308)',
        talisman_omeganum = 'OmegaNum',

        talisman_string_A = 'Wähle Funktion zum Aktivieren:',
        talisman_string_B = 'Deaktiviere Punktewertung-Animationen',
        talisman_string_C = 'Punktelimit (Erfordert Neustart des Spiels)',
        talisman_string_D = 'Berechne...',
        talisman_string_E = 'Abbrechen',
        talisman_string_F = 'Bisher berechnet: ',
        talisman_string_G = 'Nich zu berechnende Karten: ',
        talisman_string_H = 'Berechnung letzter gespielter Hand: ',
        talisman_string_I = 'Unbekannt',

        --These don't work out of the box because they would be called too early, find a workaround later?
        --Error messages can stay in English imo
        talisman_error_A = 'Could not find proper Talisman folder. Please make sure the folder for Talisman is named exactly "Talisman" and not "Talisman-main" or anything else.',
        talisman_error_B = '[Talisman] Error unpacking string: ',
        talisman_error_C = '[Talisman] Error loading string: '
}
