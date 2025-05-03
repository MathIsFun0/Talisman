return {
	descriptions = {
		Mod = {
			Talisman = {
                name = "Talisman",
                text = {"Một mod tăng giới hạn điểm của Balatro và bỏ qua hoạt ảnh ghi điểm."},
            },
		}
	}, 
	test = "j",
	talisman_vanilla = 'Gốc (e308)',
	talisman_bignum = 'BigNum (ee308)',
	talisman_omeganum = 'OmegaNum',

	talisman_string_A = 'Chọn tính năng để bật:',
	talisman_string_B = 'Tắt Hoạt Ảnh Ghi Điểm',
	talisman_string_C = 'Giới Hạn Điểm (yêu cầu khởi động lại)',
	talisman_string_D = 'Đang tính toán...',
	talisman_string_E = 'Huỷ bỏ',
	talisman_string_F = 'Phép tính đã thực hiện: ',
	talisman_string_G = 'Số lá chưa ghi điểm: ',
	talisman_string_H = 'Phép tính tay bài trước đó: ',
	talisman_string_I = 'Không rõ',

	--These don't work out of the box because they would be called too early, find a workaround later?
	talisman_error_A = 'Could not find proper Talisman folder. Please make sure the folder for Talisman is named exactly "Talisman" and not "Talisman-main" or anything else.',
	talisman_error_B = '[Talisman] Error unpacking string: ',
	talisman_error_C = '[Talisman] Error loading string: '
}
