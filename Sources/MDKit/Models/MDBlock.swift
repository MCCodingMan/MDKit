import SwiftUI

public enum MDBlock: Hashable {
    case heading(MDHeadingContext)
    case paragraph(MDTextDetailContext)
    case quote(MDQuoteContext)
    case unorderedList(MDListContext)
    case orderedList(MDListContext)
    case taskList(MDTaskListContext)
    case code(MDCodeBlockContext)
    case link(MDLinkContext)
    case image(MDImageContext)
    case table(MDTableContext)
    case divider
    case html(MDTextDetailContext)
    case footnote(MDFootnoteContext)
    case mathInline(MDTextDetailContext)
    case mathBlock(MDTextDetailContext)
}
