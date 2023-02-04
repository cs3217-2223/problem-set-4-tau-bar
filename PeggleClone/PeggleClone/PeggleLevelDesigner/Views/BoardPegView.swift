import UIKit

@IBDesignable class BoardPegView: UIImageView {
    var id: ObjectIdentifier?
    weak var delegate: BoardPegViewDelegate?

    private func setup() {
        self.isUserInteractionEnabled = true

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(didLongPressIntoBoardPeg))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapIntoBoardPeg))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanBoardPeg))

        self.addGestureRecognizer(longPressGestureRecognizer)
        self.addGestureRecognizer(tapGestureRecognizer)
        self.addGestureRecognizer(panGestureRecognizer)
    }

    convenience init(image: UIImage?, id: ObjectIdentifier) {
        self.init(image: image)
        self.id = id
        setup()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }

    @objc func didLongPressIntoBoardPeg(_ sender: UILongPressGestureRecognizer) {
        delegate?.userDidLongPress(boardPegView: self)
    }

    @objc func didTapIntoBoardPeg(_ sender: UITapGestureRecognizer) {
        delegate?.userDidTap(boardPegView: self)
    }

    @objc func didPanBoardPeg(_ sender: UIPanGestureRecognizer) {
        delegate?.userDidPan(sender: sender)
    }
}
