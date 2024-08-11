import SwiftUI

struct StoryGenerationView: View {
    
    @ObservedObject var aiChatModel: AIChatModel
    @State var placeholderString: String = "Type your message..."
//    @State private var inputText: String = "Type your message..."
    
    @Binding var model_name: String
    @Binding var chat_selection: Dictionary<String, String>?
    @Binding var title: String
    var close_chat: () -> Void
    @Binding var add_chat_dialog:Bool
    @Binding var edit_chat_dialog:Bool
    
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    @State private var scrollTarget: Int?
    @State private var clearChatAlert = false    
    
    @State private var auto_scroll = true

    @FocusState var focusedField: Field?
    
    @Namespace var bottomID
    
    let storyPrompt: String
    
    @FocusState
    private var isInputFieldFocused: Bool
    
    func scrollToBottom(with_animation:Bool = false) {
        var scroll_bug = true
#if os(macOS)
        scroll_bug = false
#else
        if #available(iOS 16.4, *){
            scroll_bug = false
        }
#endif
        if scroll_bug {
            return
        }
        if !auto_scroll {
            return
        }
        let last_msg = aiChatModel.messages.last
        
        if last_msg != nil && last_msg?.id != nil && scrollProxy != nil{
            if with_animation{
                withAnimation {
                    scrollProxy?.scrollTo("latest")
                }
            }else{
                scrollProxy?.scrollTo("latest")
            }
        }
        
    }
    
    func reload() async{
        if chat_selection == nil {
            return
        }

        aiChatModel.reload_chat(chat_selection!)
    }
    
    
    private var starOverlay: some View {
        
        Button {
            Task{
                auto_scroll = true
                scrollToBottom()                
            }
        }
        
    label: {
        Image(systemName: "arrow.down.circle")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 25, height: 25)
            .padding([.bottom, .trailing], 15)
            .opacity(0.4)
    }
    .buttonStyle(BorderlessButtonStyle())
    }

    var body: some View {
        VStack{
            VStack{
                if aiChatModel.state == .loading{
                    VStack {
                        ProgressView(value: aiChatModel.load_progress)
                    }
                }
            }
            ScrollViewReader { scrollView in
                VStack {
                    Button {
                        aiChatModel.messages = []
                        save_chat_history(aiChatModel.messages, "FIXED - chat.json")
                        self.aiChatModel.chat = nil
                    } label: {
                        Text("Clear")
                    }

                    List {
                        ForEach(aiChatModel.messages, id: \.id) { message in
//                            MessageView(message: message).id(message.id)
                            if message.sender == .system {
                                Text("Message: \(message.text)")
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .overlay(starOverlay, alignment: .bottomTrailing)
                }
                .onChange(of: aiChatModel.AI_typing){
                    scrollToBottom(with_animation: false)
                }
                
                .disabled(chat_selection == nil)
                .onAppear(){
                    scrollProxy = scrollView
                    scrollToBottom(with_animation: false)                    
                }
            }
            .frame(maxHeight: .infinity)
            .disabled(aiChatModel.state == .loading)
            .onChange(of: chat_selection) {
                Task {
                    if chat_selection == nil{
                        close_chat()
                    }
                    else{
                        await self.reload()
                    }
                }
            }
            .onTapGesture { location in
                focusedField = nil
                auto_scroll = false
            }
            .navigationTitle("Brewing Story")
        }
        .onAppear {
            sendDelayedMessage()
        }
        .onAppear {
            if aiChatModel.modelURL.isEmpty {
            }
            Task {
//                print("On appear task")
                if chat_selection == nil{
                    close_chat()
                }
                else{
                    await self.reload()
                }
            }
        }
    }
    
    // Function to send a default message
    private func sendDefaultMessage() {
//        print("Reached Default message func")
        let defaultMessage = "Hello, how are you?"  // Default message
        aiChatModel.send(message: defaultMessage, img_path: nil)
    }
    
    func sendDelayedMessage() {
        // Delay of 2 seconds before sending the message
        let messageToSend = "Tell me a Joke"
//        let messageToSend = storyPrompt
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            aiChatModel.send(message: messageToSend, img_path: nil)
//            print("Default message sent after delay")
        }
    }
}

struct StoryGenerationView_Previews: PreviewProvider {
    @State static var modelName: String = "defaultModel"
    @State static var chatSelection: Dictionary<String, String>? = [
        "chat": "Phi-3 (Custom) - 1_1715767669.json",
        "title": "Phi-3 FIXED",
        "message": "llama ctx:1024",
        "time": "10:30 AM",
        "model": "Phi-3-mini-128k-instruct.IQ4_NL.gguf",
        "icon": "ava0",
        "mmodal": "0"
    ]
    @State static var title: String = "Sample Title"
    @State static var addChatDialog: Bool = false
    @State static var editChatDialog: Bool = false

    static var previews: some View {
        @StateObject var aiChatModel = AIChatModel()
        StoryGenerationView(
            aiChatModel: aiChatModel, model_name: $modelName,
            chat_selection: $chatSelection,
            title: $title,
            close_chat: { print("Close chat action") },
            add_chat_dialog: $addChatDialog,
            edit_chat_dialog: $editChatDialog,
            storyPrompt: "This is a sample story prompt used for preview."
        )
    }
}
