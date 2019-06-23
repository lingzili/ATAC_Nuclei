library(tidyverse)
library(readxl)

# Load data set
ATAC_QC <- read_excel("ATAC_QC.xlsx", col_types = c(
  "text", "text", "text", "text", "text", "text",
  "text", "numeric", "numeric", "numeric",
  "numeric", "numeric", "numeric", "numeric", "numeric"
))

View(ATAC_QC)

# Subset data
ATAC_QC <- subset(ATAC_QC, select = -c(1, 2, 7))

ATAC_QC <- ATAC_QC[c(3:6), ]

View(ATAC_QC)

# Set standard theme for barplot
standard_theme_barplot <- theme(
  axis.line = element_line(colour = "black"),
  axis.text.x = element_text(color = "black", size = 16, face = "bold", angle = 90, hjust = 1),
  axis.text.y = element_text(color = "black", size = 16, face = "bold"),
  axis.title.x = element_text(color = "black", size = 18, face = "bold"),
  axis.title.y = element_text(color = "black", size = 18, face = "bold"),
  strip.text.x = element_text(color = "black", size = 18, face = "bold"),
  strip.background = element_rect(fill = "white"),
  legend.title = element_text(color = "black", size = 18, face = "bold"),
  legend.text = element_text(color = "black", size = 18, face = "bold"),
  legend.key = element_rect(fill = "white"), # Remove grey background of the legend
  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  panel.background = element_blank(),
  panel.border = element_rect(colour = "black", fill = NA, size = 2),
  plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
  plot.title = element_text(color = "black", size = 20, face = "bold")
)

# Barplot for read counts
read_p1 <- ATAC_QC %>%
  ggplot(aes(x = ID, y = Read_Count, fill = PCR_Cycle))

read_p2 <- read_p1 +
  geom_bar(stat = "identity", position = position_dodge()) +
  ylim(0, 60000000) +
  labs(title = "Reads per library", x = NULL, y = "Reads") +
  standard_theme_barplot +
  scale_x_discrete(labels = c("SM4227" = "Ins1creTRAP Tn5 1", "SM4492" = "TRAP Tn5 1", "SM4493" = "TRAP Tn5 0.5", "SM4494" = "TRAP Tn5 0.25"))

read_p2

ggsave(here::here("Read_Count_230619.png"), read_p2) # Saving 8.58 x 5.7 in image

# Barplot for alignment rates
align_p1 <- ATAC_QC %>%
  ggplot(aes(x = ID, y = Align_Rate_Percent, fill = ID))

align_p2 <- align_p1 +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = Align_Rate_Percent), vjust = 0, color = "black", position = position_dodge(0.9), size = 5) +
  ylim(0, 100) +
  labs(title = "Alignment rate to mouse genome mm10", x = NULL, y = "% Alignment") +
  guides(fill = "none") + # Remove legends
  standard_theme_barplot +
  scale_x_discrete(labels = c("SM4227" = "Ins1creTRAP Tn5 1", "SM4492" = "TRAP Tn5 1", "SM4493" = "TRAP Tn5 0.5", "SM4494" = "TRAP Tn5 0.25")) +
  scale_fill_manual(values = c("#56B4E9", "#56B4E9", "#56B4E9", "#56B4E9"))

align_p2

ggsave(here::here("Align_Rate_230619.png"), align_p2) # Saving 8.58 x 5.7 in image

# Barplot for alignment fractions
align_p1 <- ATAC_QC %>%
  gather(key = "Aligned_Concordantly", value = "Percent", Align_Con_0_Rate_Percent, Align_Con_1_Rate_Percent, Align_Con_Multi_Rate_Percent) %>%
  ggplot(aes(x = ID, y = Percent, fill = Aligned_Concordantly))

align_p2 <- align_p1 +
  geom_bar(stat = "identity") +
  labs(title = "Alignment quality", x = NULL, y = "% Reads") +
  standard_theme_barplot +
  scale_x_discrete(labels = c("SM4227" = "Ins1creTRAP Tn5 1", "SM4492" = "TRAP Tn5 1", "SM4493" = "TRAP Tn5 0.5", "SM4494" = "TRAP Tn5 0.25")) +
  scale_fill_discrete(name = "Align concordantly ", labels = c("Zero time", "Once", "Multiple times"))

align_p2

ggsave(here::here("Align_Quality_240619.png"), align_p2) # Saving 8.58 x 5.31 in image
