(in-package :vk)


(defgeneric os-window-should-close-p (window))

(defgeneric (setf os-window-should-close-p) (value window))

(defgeneric (setf os-window-title) (title window))

(defgeneric get-os-window-pos (window))

(defgeneric set-os-window-pos (window x y))

(defgeneric get-os-window-cursor-pos (window))

(defgeneric get-os-window-size (window))

(defgeneric focus-os-window (window))

(defgeneric hide-os-window (window))

(defgeneric show-os-window (window))

(defgeneric maximize-os-window (window))

(defgeneric restore-os-window (window))

(defgeneric iconify-os-window (window))

(defgeneric get-os-window-frame-size (window))

(defgeneric get-os-window-framebuffer-size (window))

(defgeneric window-framebuffer-size (window))

(defgeneric set-os-window-size (window height width))

(defgeneric set-os-window-aspect-ratio (window numer denom))

(defgeneric set-os-window-size-limits (window min-width min-height max-width max-height))

(defclass handle-mixin ()
  ((handle :accessor h :initarg :handle)))

#++
(defmethod h ((o null))
  nil)

(defgeneric wait-events (window))

(defgeneric window-display (window))

(defgeneric create-native-window-surface (window instance allocator))

(defgeneric ptr-value (window pointer))

