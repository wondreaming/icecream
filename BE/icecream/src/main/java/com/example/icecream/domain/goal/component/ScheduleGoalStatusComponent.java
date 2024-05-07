package com.example.icecream.domain.goal.component;

import com.example.icecream.domain.goal.document.GoalStatus;
import com.example.icecream.domain.goal.repository.mongodb.GoalStatusRepository;
import com.example.icecream.domain.user.entity.User;
import com.example.icecream.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class ScheduleGoalStatusComponent {

    private final UserRepository usersRepository;
    private final GoalStatusRepository goalStatusRepository;

    @Scheduled(cron = "0 30 0 * * *")  // 초, 분, 시, 일, 월, 요일
    public void scheduleGoalStatus() {
        List<User> users = usersRepository.findAll();
        users.forEach(user -> {
            int userId = user.getId();
            GoalStatus goalStatus = goalStatusRepository.findByUserId(userId);
            Map<LocalDate, Integer> result = goalStatus.getResult();
            if (result.get(LocalDate.now().minusDays(1)) == 0) {
                result.put(LocalDate.now().minusDays(1), 1);
                goalStatusRepository.save(goalStatus);
            }
        });
    }
}
