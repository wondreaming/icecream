package com.example.icecream.common.service;

import com.example.icecream.domain.user.repository.ParentChildMappingRepository;
import com.example.icecream.domain.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.transaction.annotation.Transactional;

@Transactional(readOnly = true)
@AllArgsConstructor
public abstract class CommonService {

    protected final UserRepository userRepository;
    protected final ParentChildMappingRepository ParentChildMappingRepository;

    protected boolean isUserExist(Integer userId) {
        return userRepository.existsById(userId);
    }

    protected boolean isParentUserWithPermission(Integer parentId, Integer childId) {
        return ParentChildMappingRepository.existsByParentIdAndChildId(parentId, childId);
    }

}
