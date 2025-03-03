package org.opensearch.migrations.bulkload.common;

import java.util.List;
import java.util.function.Predicate;

public class FilterScheme {
    private FilterScheme() {}

    public static Predicate<String> filterByAllowList(List<String> allowlist) {
        return item -> {
            boolean accepted;
            // By default allow all non-system indices (not starting with '.') and .kibana* indices
            if (allowlist == null || allowlist.isEmpty()) {
                accepted = !item.startsWith(".") || item.startsWith(".kibana");
            } else {
                accepted = allowlist.contains(item);
            }
            return accepted;
        };
    }

    public static String getTargetIndexName(String sourceIndexName) {
        if (sourceIndexName.startsWith(".kibana")) {
            return sourceIndexName.replace(".kibana", ".migrated_kibana");
        }
        return sourceIndexName;
    }
}
