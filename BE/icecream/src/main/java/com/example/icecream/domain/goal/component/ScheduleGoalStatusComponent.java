package com.example.icecream.domain.goal.component;

import com.example.icecream.domain.goal.document.GoalStatus;
import com.example.icecream.domain.goal.repository.mongodb.GoalStatusRepository;
import com.example.icecream.domain.user.entity.Users;
import com.example.icecream.domain.user.repository.UsersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class ScheduleGoalStatusComponent {

    private final UsersRepository usersRepository;
    private final GoalStatusRepository goalStatusRepository;

    @Scheduled(cron = "0 30 0 * * *")  // 초, 분, 시, 일, 월, 요일
    public void scheduleGoalStatus() {
        List<Users> users = usersRepository.findAll();
        users.forEach(user -> {
            int userId = user.getId();
            GoalStatus goalStatus = goalStatusRepository.findByUserId(userId);
            List<Map<LocalDate, Integer>> result = goalStatus.getResult();
            Map<LocalDate, Integer> lastResult = result.get(result.size() - 1);
            if (lastResult.get(LocalDate.now()) == 0) {
                lastResult.put(LocalDate.now(), 1);
                goalStatusRepository.save(goalStatus);
            }
        });
    }
}
