//
//  DetailViewController.swift
//  ios101-project6-tumblr
//

import UIKit
import Nuke

class DetailViewController: UIViewController {

    @IBOutlet weak var captionTextView: UITextView!

    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Post Details"
        captionTextView.isEditable = false

        let captionText = post.caption.trimHTMLTags() ?? ""
        captionTextView.attributedText = NSAttributedString(string: captionText, attributes: [
            .font: UIFont.systemFont(ofSize: 18)
        ])

        if let photo = post.photos.first {
            loadImageAndInsert(from: photo.originalSize.url)
        }
    }

    func loadImageAndInsert(from url: URL) {
        ImagePipeline.shared.loadImage(with: url) { [weak self] result in
            guard let self = self, case .success(let response) = result else {
                return // If download fails, do nothing. The text is already visible.
            }

            DispatchQueue.main.async {
                let attachment = NSTextAttachment(image: response.image)

                let textViewWidth = self.captionTextView.bounds.width - (self.captionTextView.textContainerInset.left + self.captionTextView.textContainerInset.right + self.captionTextView.textContainer.lineFragmentPadding * 2)
                let aspectRatio = response.image.size.height / response.image.size.width
                attachment.bounds = CGRect(x: 0, y: 0, width: textViewWidth, height: textViewWidth * aspectRatio)

                let imageAttributedString = NSMutableAttributedString(attachment: attachment)
                
                imageAttributedString.append(NSAttributedString(string: "\n\n"))
                
                let existingText = self.captionTextView.attributedText ?? NSAttributedString()
                
                imageAttributedString.append(existingText)
                
                self.captionTextView.attributedText = imageAttributedString
            }
        }
    }
}
