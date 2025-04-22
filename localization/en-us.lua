return {
        descriptions = {
                Mod = { 
                        Talisman = {
                                name = "Talisman",
                                text = {"A mod that increases Balatro's score limit and skips scoring animations. pee pee poo poo"},
                        }
                }
        }, 
        test = "j",
        talisman_vanilla = 'Vanilla (e308)',
        talisman_bignum = 'BigNum (ee308)',
        talisman_omeganum = 'OmegaNum',
        
        talisman_string_A = 'Select features to enable:',
        talisman_string_B = 'Disable Scoring Animations',
        talisman_string_C = 'Score Limit (requires game restart)',
        talisman_string_D = 'Calculating...',
        talisman_string_E = 'Abort',
        talisman_string_F = 'Elapsed calculations: ',
        talisman_string_G = 'Cards yet to score: ',
        talisman_string_H = 'Calculations last played hand: ',
        talisman_string_I = 'Unknown',

        --These don't work out of the box because they would be called too early, find a workaround later?
        talisman_error_A = 'Could not find proper Talisman folder. Please make sure the folder for Talisman is named exactly "Talisman" and not "Talisman-main" or anything else.',
        talisman_error_B = '[Talisman] Error unpacking string: ',
        talisman_error_C = '[Talisman] Error loading string: '
}
