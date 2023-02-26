import UIKit

@IBDesignable class BoardObjectView: UIImageView {
    var id: ObjectIdentifier?
    weak var delegate: BoardObjectViewDelegate?

    private func setup() {
        self.isUserInteractionEnabled = true

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(didLongPressBoardObject))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBoardObject))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanBoardObject))

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
        self.clipsToBounds = true
    }

    @objc func didLongPressBoardObject(_ sender: UILongPressGestureRecognizer) {
        delegate?.userDidLongPress(boardObjectView: self)
    }

    @objc func didTapBoardObject(_ sender: UITapGestureRecognizer) {
        delegate?.userDidTap(boardObjectView: self)
    }

    @objc func didPanBoardObject(_ sender: UIPanGestureRecognizer) {
        delegate?.userDidPan(sender: sender)
    }
}
