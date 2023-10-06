package com.panda.back.domain.item.service;

import com.panda.back.domain.item.dto.ItemRequestDto;
import com.panda.back.domain.item.dto.ItemResponseDto;
import com.panda.back.domain.item.entity.Item;
import com.panda.back.domain.item.repository.ItemRepository;
import com.panda.back.domain.member.entity.Member;
import com.panda.back.domain.member.jwt.MemberDetailsImpl;
import com.panda.back.global.S3.S3Uploader;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URL;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemService {
    private final ItemRepository itemRepository;
    private final S3Uploader s3Uploader;

    @Transactional
    public ItemResponseDto createItem(List<MultipartFile> images, ItemRequestDto itemRequestDto, Member member) throws IOException {

        Item item = new Item(itemRequestDto, member);
        if (images.isEmpty()) {
            throw new IllegalArgumentException("이미지가 없습니다.");
        }
        for(MultipartFile image : images){
            String fileName = s3Uploader.upload(image, "image");
            URL imageUrl = new URL(fileName);
            item.addImages(imageUrl);
        }

        itemRepository.save(item);

        return new ItemResponseDto(item);
    }


    public ItemResponseDto getItemById(Long itemId) {
        Item item = itemRepository.findById(itemId).orElseThrow(
                () -> new IllegalArgumentException("해당 아이템이 없습니다.")
        );
        return new ItemResponseDto(item);
    }
}
