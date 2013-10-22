require 'zlib'
class Shockwave
	def self.dim(file)
		contents = IO.read(file)
		sig = contents[0..2]
		len = contents[4..7].unpack('V').join.to_i
		
		if sig == 'CWS'
			body = Zlib::Inflate.inflate( contents[8..len] )
			contents = contents[0..7] + body
		end
		
		nbits = contents[8] >> 3
		rectbits = 5 + nbits * 4
		rectbytes = (rectbits.to_f / 8).ceil
		rect = contents[8..(8 + rectbytes)].unpack("#{'B8' * rectbytes}").join()
		
		dim = Array.new
		4.times do |n|
			s = 5 + (n * nbits)
			e = s + (nbits - 1)
			dim[n] = rect[s..e].to_i(2)
		end
		
		w = (dim[1] - dim[0]) / 20 # 20 twips/pixel
		h = (dim[3] - dim[2]) / 20 # 20 twips/pixel
		
		return [w, h]
	end
end