import SwiftUI

struct ChatItem: View {
    
    var chatImage: String = ""
    var chatTitle: String = ""
    var message: String = ""
    var time: String = ""
    var model: String = ""
    var chat: String = ""
//    @Binding var chat_selection: String?
    @Binding var model_name: String
    @Binding var title: String    
    var close_chat: () -> Void
    
    var body: some View {
        HStack{
                Image(chatImage+"_85")
                    .resizable()
                    .background( Color("color_bg_inverted").opacity(0.05))
                    .padding(EdgeInsets(top: 7, leading: 5, bottom: 7, trailing: 5))
                    .frame(width: 85, height: 85)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        Text(chatTitle)
                            .fontWeight(.semibold)
//                            .font(.title3)
                            .padding(.top, 3)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    
                    Text(message)
                        .foregroundColor(Color("color_bg_inverted").opacity(0.5))
                        .font(.footnote)
                        .opacity(0.6)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    
                }
        }
        
    }
}
