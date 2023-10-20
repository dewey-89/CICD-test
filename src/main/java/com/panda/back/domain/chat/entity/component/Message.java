package com.panda.back.domain.chat.entity.component;

import com.panda.back.domain.chat.dto.ReceiveMessage;
import com.panda.back.domain.chat.type.MessageType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Message {
    // 메시지 인덱스
    private Integer idx;

    private MessageType type;

    private String sender;

    private String content;

    private LocalDateTime sentAt;

    public Message(ReceiveMessage receiveMessage, Integer idx) {
        this.idx = idx + 1;
        this.type = receiveMessage.getType();
        this.sender = receiveMessage.getSender();
        this.content = receiveMessage.getContent();
        this.sentAt = LocalDateTime.now();
    }
}
